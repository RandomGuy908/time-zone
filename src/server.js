const http = require('http');
const fs = require('fs');
const path = require('path');
const root = path.join(__dirname, 'public');
const types={'.html':'text/html; charset=utf-8','.js':'text/javascript; charset=utf-8','.css':'text/css; charset=utf-8','.svg':'image/svg+xml'};
http.createServer((req,res)=>{
  let p=req.url.split('?')[0]; if(p==='/') p='/index.html';
  const file=path.normalize(path.join(root,p));
  if(!file.startsWith(root)){res.writeHead(403);return res.end('Forbidden');}
  fs.readFile(file,(e,d)=>{if(e){res.writeHead(404);return res.end('Not found');}res.writeHead(200,{'Content-Type':types[path.extname(file)]||'application/octet-stream','Cache-Control':'no-cache'});res.end(d);});
}).listen(process.env.PORT||3000,'0.0.0.0',()=>console.log('Time Zone Converter listening on port '+(process.env.PORT||3000)));
