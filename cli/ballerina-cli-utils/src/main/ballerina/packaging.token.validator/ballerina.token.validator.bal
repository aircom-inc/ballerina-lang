import ballerina/http;

endpoint http:Listener echoEP {
    port:9090
};

@http:ServiceConfig {basePath:"/listener"}
service<http:Service> echo bind echoEP {

string serviceLevelStringVar = "Hello World";

    @http:ResourceConfig {
        methods:["GET"],
        path:"/message"
    }
    echo (endpoint conn, http:Request req) {
        http:Response res = new;
        res.setStringPayload(serviceLevelStringVar);
        _ = conn -> respond(res);
        echoEP.stop();
    }
}
