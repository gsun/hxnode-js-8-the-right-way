import js.npm.Express;
import js.npm.express.Morgan;
import js.Node.console;
import js.npm.NodeEnvFile;
import js.Node.process;
import js.lib.Error;
import js.npm.elasticsearch.Client;
using Lambda;

class B4Server {
    static function main() {
        try {
            new NodeEnvFile(js.Node.__dirname + '/.env');
        } catch(e : Error) {}
        
        var app = new Express();
        app.use(new Morgan(MorganFormat.dev));
        
        app.get('/hello/:name', (req, res) -> {
            res.status(200).json({'hello': req.params.name});
        });
        
        app.get('/api/search/books/:field/:query', (req, res) -> {
            var client = new Client({
                host: '${process.env["es_host"]}:${process.env["es_port"]}',
                log: 'trace'
            });
            var esReq = haxe.Json.parse('{
                "index" : "books",
                "body" : {
                    "query" : {
                        "match" : {
                            "${req.params.field}" : "${req.params.query}"
                        }
                    }
                }
            }');
            client.search(esReq, function(error, esRes:SearchResult<Dynamic>) {
                if (error != null) {
                    res.status(502);
                    return;
                } else {
                    res.status(200).json([for (hit in esRes.hits.hits) {_source : hit._source}]);
                }
            });
        });
        
        app.listen(Std.parseInt(process.env["port"]), () -> console.log('Ready.'));
    }
}