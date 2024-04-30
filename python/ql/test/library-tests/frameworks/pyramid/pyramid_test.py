from pyramid.view import view_config
from pyramid.config import Configurator
from pyramid.response import Response
from wsgiref.simple_server import make_server

def ignore(*args, **kwargs): pass
ensure_tainted = ensure_not_tainted = ignore

@view_config(route_name="test1") # $ routeSetup
def test1(request): # $ requestHandler 
    ensure_tainted(
        request,                   # $ tainted

        request.accept,            # $ tainted
        request.accept_charset,    # $ tainted
        request.accept_encoding,   # $ tainted
        request.accept_language,   # $ tainted
        request.authorization,     # $ tainted
        request.cache_control,     # $ tainted
        request.client_addr,       # $ tainted
        request.content_type,      # $ tainted
        request.domain,            # $ tainted
        request.host,              # $ tainted
        request.host_port,         # $ tainted
        request.host_url,          # $ tainted
        request.if_match,          # $ tainted
        request.if_none_match,     # $ tainted
        request.if_range,          # $ tainted   
        request.pragma,            # $ tainted
        request.range,             # $ tainted
        request.referer,           # $ tainted
        request.referrer,          # $ tainted
        request.user_agent,        # $ tainted

        request.as_bytes,          # $ tainted

        request.body,              # $ tainted
        request.body_file.read(),         # $ tainted
        request.body_file_raw.read(),     # $ tainted
        request.body_file_seekable.read(),# $ tainted

        request.json,              # $ tainted
        request.json_body,         # $ tainted
        request.json['a']['b'][0]['c'],   # $ tainted

        request.text,               # $ tainted

        request.path,               # $ tainted
        request.path_info,          # $ tainted
        request.path_info_peek(),   # $ tainted
        request.path_info_pop(),    # $ tainted
        request.path_qs,            # $ tainted
        request.path_url,           # $ tainted
        request.query_string,       # $ tainted

        request.url,                # $ tainted
        request.urlargs,            # $ tainted
        request.urlvars,            # $ tainted

        request.GET['a'],           # $ tainted
        request.POST['b'],          # $ tainted
        request.cookies['c'],       # $ tainted
        request.params['d'],        # $ tainted
        request.headers['X-My-Header'],   # $ tainted
        request.GET.values(),       # $ tainted

        request.copy(),             # $ tainted
        request.copy_get(),         # $ tainted
        request.copy().GET['a'],    # $ tainted
        request.copy_get().body     # $ tainted
        ) 

    return Response("Ok") # $ HttpResponse responseBody="Ok" mimetype=text/html

def test2(request): # $ requestHandler 
    ensure_tainted(request) # $ tainted

    resp = Response("Ok", content_type="text/plain") # $ HttpResponse responseBody="Ok" mimetype=text/plain
    resp.body = "Ok2" # $ HttpResponse responseBody="Ok2" SPURIOUS: mimetype=text/html
    return resp

@view_config(route_name="test3", renderer="string") # $ routeSetup
def test3(ctx, req): # $ requestHandler 
    ensure_tainted(req) # $ tainted
    resp = req.response # $ HttpResponse mimetype=text/html
    resp.set_cookie("hi", "there") # $ CookieWrite CookieName="hi" CookieValue="there"
    resp.set_cookie(value="there", name="hi") # $ CookieWrite CookieName="hi" CookieValue="there"
    return "Ok" # $ HttpResponse responseBody="Ok" mimetype=text/html

if __name__ == "__main__":
    with Configurator() as config:
        for i in range(1,4):
            config.add_route(f"test{i}", f"/test{i}")
        config.add_view(test2, route_name="test2") # $ routeSetup
        config.scan()
        server = make_server('127.0.0.1', 8000, config.make_wsgi_app())
        print("serving")
        server.serve_forever()
