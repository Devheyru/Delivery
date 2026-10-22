const http = require('http');
const https = require('https');

const TARGET = 'https://minoodelivery.havanacademy.com';
const PORT = 5050;

const server = http.createServer((req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', '*');

  console.log(`[Proxy] ${req.method} ${req.url}`);

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  const targetUrl = new URL(req.url, TARGET);
  const headers = { ...req.headers };
  delete headers['host'];
  delete headers['origin'];
  delete headers['referer'];
  headers['user-agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36';
  headers['accept'] = headers['accept'] || '*/*';

  const options = {
    method: req.method,
    headers: headers,
  };

  const proxyReq = https.request(targetUrl, options, (proxyRes) => {
    const resHeaders = { ...proxyRes.headers };
    resHeaders['access-control-allow-origin'] = '*';
    resHeaders['access-control-allow-methods'] = 'GET, POST, PUT, DELETE, OPTIONS';
    resHeaders['access-control-allow-headers'] = '*';
    res.writeHead(proxyRes.statusCode, resHeaders);
    proxyRes.pipe(res);
  });

  proxyReq.on('error', (err) => {
    res.writeHead(502, { 'content-type': 'application/json' });
    res.end(JSON.stringify({ error: err.message }));
  });

  req.pipe(proxyReq);
});

server.listen(PORT, '127.0.0.1', () => {
  console.log(`CORS Proxy running on http://127.0.0.1:${PORT} -> ${TARGET}`);
});
