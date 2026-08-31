var CACHE='sabte-roidadha-v2';
var CORE=['./','index.html','manifest.json','icons/favicon.png','icons/icon-192.png','icons/icon-512.png','icons/icon-maskable-512.png'];

self.addEventListener('install',function(e){
  e.waitUntil(caches.open(CACHE).then(function(c){return c.addAll(CORE)}).then(function(){return self.skipWaiting()}));
});

self.addEventListener('activate',function(e){
  e.waitUntil(caches.keys().then(function(ks){
    return Promise.all(ks.filter(function(k){return k!==CACHE}).map(function(k){return caches.delete(k)}));
  }).then(function(){return self.clients.claim()}));
});

self.addEventListener('fetch',function(e){
  var url=new URL(e.request.url);
  if(e.request.method!=='GET'||url.origin!==self.location.origin)return;
  // صفحات (navigation): اول شبکه تا نسخهٔ جدید همیشه برسد؛ در آفلاین از کش
  if(e.request.mode==='navigate'){
    e.respondWith(
      fetch(e.request).then(function(res){
        if(res&&res.status===200){var cp=res.clone();caches.open(CACHE).then(function(c){c.put('index.html',cp)})}
        return res;
      }).catch(function(){return caches.match('index.html')})
    );
    return;
  }
  // بقیه منابع: کش-اول
  e.respondWith(
    caches.match(e.request,{ignoreSearch:true}).then(function(hit){
      if(hit)return hit;
      return fetch(e.request).then(function(res){
        if(res&&res.status===200&&res.type==='basic'){var cp=res.clone();caches.open(CACHE).then(function(c){c.put(e.request,cp)})}
        return res;
      });
    })
  );
});
