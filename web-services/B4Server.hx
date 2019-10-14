import js.npm.Express;
import js.npm.express.Morgan;
import js.Node.console;
import js.npm.NodeEnvFile;
import js.Node.process;
import js.lib.Error;
import js.npm.elasticsearch.Client;
import js.lib.Promise;
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
            var client = new Client({
                host: '${process.env["es_host"]}:${process.env["es_port"]}',
                log: 'trace'
            });
            client.search(esReq, (error, esRes:SearchResult<Dynamic>) -> {
                if (error != null) {
                    res.status(502);
                    return;
                } else {
                    res.status(200).json([for (hit in esRes.hits.hits) {_source : hit._source}]);
                }
            });
        });
        
        app.get('/api/search/suggests/:field/:query', (req, res) -> {
            var esReq = haxe.Json.parse('{
                "index" : "books",
                "body" : {
                    "query" : {
                        "term" : {
                            "${req.params.field}" : "${req.params.query}"
                        }
                    }
                }
            }');
            var p = new Promise((resolve, reject) -> {
                var client = new Client({
                    host: '${process.env["es_host"]}:${process.env["es_port"]}',
                    log: 'trace'
                });
                client.search(esReq, (error, esRes:SearchResult<Dynamic>) -> {
                    if (error != null) {
                        reject(error);
                        return;
                    } else {
                        resolve(esRes);
                    }
                });
            });
            p.then((esRes) -> {
                        res.status(200).json([for (hit in esRes.hits.hits) {_source : hit._source}]);
                        return;
                    },
                    (err) -> {
                        res.status(502);
                        return;
                    });
        });
        
        app.listen(Std.parseInt(process.env["port"]), () -> console.log('Ready.'));
    }
}