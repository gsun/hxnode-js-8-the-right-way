import js.npm.Express;
import js.npm.express.Morgan;
import js.Node.console;
import js.npm.NodeEnvFile;
import js.Node.process;
import js.lib.Error;
import js.npm.Request;
import js.lib.Promise;
using Lambda;

class B4ServerRequest {
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
            var path = 'http://${process.env["es_host"]}:${process.env["es_port"]}/${process.env["books_index"]}/_search';
            var options = haxe.Json.parse('{
                "url" : "${path}",
                "json" : true,
                "body" : {
                    "query" : {
                        "match" : {
                            "${req.params.field}" : "${req.params.query}"
                        }
                    }   
                }
            }');
            Request.debug = true;
            var r = Request.construct();
            r.get(options, (err, esRes, esResBody) -> {
              if (err != null) {
                res.status(502);
                return;
              }
              var p:{hits:{hits:Array<{_source:Dynamic}>}} = cast esResBody;
              res.status(200).json([for (hit in p.hits.hits) {_source : hit._source}]);
            });
        });
        
        app.get('/api/suggests/:field/:query', (req, res) -> {
            var path = 'http://${process.env["es_host"]}:${process.env["es_port"]}/${process.env["books_index"]}/_search';
            var options = haxe.Json.parse('{
                "url" : "${path}",
                "json" : true,
                "body" : {
                    "query" : {
                        "term" : {
                            "${req.params.field}" : "${req.params.query}"
                        }
                    }   
                }
            }');
            var p = new Promise((resolve, reject) -> {
                Request.debug = true;
                var r = Request.construct();
                r.get(options, (err, esRes, esResBody) -> {
                  if (err != null) {
                      reject(err);
                      return;
                  } else {
                      resolve(esResBody);
                  }
                });
            });
            p.then((esRes) -> {
                        var p:{hits:{hits:Array<{_source:Dynamic}>}} = cast esRes;
                        res.status(200).json([for (hit in p.hits.hits) {_source : hit._source}]);
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