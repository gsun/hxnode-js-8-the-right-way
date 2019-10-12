import js.node.Http;
import js.Node.console;

class WebServer {
    static function main() {
        Http.createServer(function(req, res) {
            res.writeHead(200, {'Content-Type': 'text/plain'});
            res.end('Hello World\n');
        }).listen(60700, () -> console.log('Ready!'));
    }
}