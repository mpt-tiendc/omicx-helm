
local request_uri = ngx.var.request_uri
local remote_addr = ngx.var.remote_addr
local request_method = ngx.var.request_method
local request_token = ngx.var.http_Authorization or "Bearer " .. (ngx.var["cookie_Abp.AuthToken"] or '');
local tenant_id = ngx.var["cookie_Abp.Tenantid"] or '';

-- ngx.log(ngx.NOTICE, "request uri: ", request_uri)
-- ngx.log(ngx.NOTICE, "method: ", request_method)
ngx.log(ngx.ERR, "method: " .. request_method .. " , path: ".. request_uri .. " , ip: ".. remote_addr )
-- ngx.log(ngx.ERR, "request_token: " .. request_token);

local backend_url = os.getenv("BACKEND_URL")
-- ngx.log(ngx.NOTICE, "backend_url: ", backend_url)
if backend_url == nil then
   ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
   -- return false
end

local str = string.format('{"method":"%s","pattern":"%s","clientIP":"%s"}', request_method, request_uri, remote_addr)
ngx.log(ngx.INFO, "request body: ", str)
print("request body: "..str)

local httpc = require("resty.http").new()
local res, err = httpc:request_uri(backend_url, {
   method = "POST",
   body = str,
   headers = {
      ["Content-Type"] = "application/json",
      ["Authorization"] = request_token,
      ["Abp.Tenantid"] = tenant_id,
   },
})
if not res then
   ngx.log(ngx.ERR, "request failed: ", err)
   -- return false
   ngx.status = ngx.HTTP_UNAUTHORIZED
   ngx.say("{}")
   return ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

local status = res.status
print("Backend return status: "..status)
ngx.log(ngx.INFO,"Backend return status: ", status)
if status ~= 200 then
   ngx.status = status
   ngx.say("{}")
   return ngx.exit(status)
end