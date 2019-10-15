import js.Node.process;
import js.Node.console;
import js.npm.Commander.root as program;
import js.npm.Request;
import js.node.Readline;
import js.node.Fs;

class EscluRequest {
    static function handleResponse(err, res, body) {
      if (err != null) throw err;
      if (program.json) {
        console.log(haxe.Json.stringify(body));
      } else {
        console.log(body);
      }
    };

    static function main() {
        program
          .version('1.0.0')
          .description('Elasticsearch Command Line Utilities')
          .usage('[options] <command> [...]')
          .option('-o, --host <hostname>', 'hostname [localhost]', 'localhost')
          .option('-p, --port <number>', 'port number [9200]', '9200')
          .option('-j, --json', 'format output as JSON');
          
        program
          .command('get [path]')
          .description('perform an HTTP GET request for path (default is /)')
          .action((path='') -> {
            var options = {
              url: 'http://${program.host}:${program.port}/${path}',
              json: program.json,
            };
            var r = Request.construct();
            r.get(options, handleResponse);
          });

        program
          .command('create-index <index>')
          .description('create an index')
          .action((index) -> {
            if (program.index != null) {
              var msg = 'No index specified! Use --index <name>';
              if (!program.json) throw new js.lib.Error(msg);
              console.log(haxe.Json.stringify({error: msg}));
            }
            var url = 'http://${program.host}:${program.port}/${program.index}';
            var r = Request.construct();
            r.put(url, handleResponse);
          });

        program
          .command('list-indices')
          .alias('li')
          .description('get a list of indices in this cluster')
          .action(() -> {
            var path = program.json ? '_all' : '_cat/indices?v';
            var url = 'http://${program.host}:${program.port}/${path}';
            var r = Request.construct();
            r.get({url: url, json: program.json}, handleResponse);
          });

        program
          .command('delete-index <index>')
          .description('delete an index')
          .action((index) -> {
            if (program.index != null) {
              var msg = 'No index specified! Use --index <name>';
              if (!program.json) throw new js.lib.Error(msg);
              console.log(haxe.Json.stringify({error: msg}));
            }
            var url = 'http://${program.host}:${program.port}/${program.index}';
            var r = Request.construct();
            r.del(url, handleResponse);
          });

        program
          .command('bulk <file>')
          .description('read and perform bulk options from the specified file')
		  .option('-i, --index <name>', 'which index to use')
          .option('-t, --type <type>', 'default type for bulk operations')
          .action((file, options) -> {
			if (options.index == null || options.type == null) {
			  var msg = 'No index specified! Use --index <name>';
			  if (!program.json) throw new js.lib.Error(msg);
			  console.log(haxe.Json.stringify({error: msg}));
			}
            Fs.stat(file, (err, stats) -> {
              if (err != null) {
                if (program.json) {
                  console.log(haxe.Json.stringify(err));
                }
                throw err;
              }

              var opt = {
                url: 'http://${program.host}:${program.port}/${options.index}/${options.type}/_bulk',
                json: true,
                headers: {
                  "content-length" : stats.size,
                  "content-type" : 'application/json',
                }
              };
              var req = Request.construct().post(opt);
              var stream = Fs.createReadStream(file);
              stream.pipe(req).pipe(process.stdout);
            });
          });

        program
          .command('query [queries...]')
          .alias('q')
          .description('perform an Elasticsearch query')
          .option('-i, --index <name>', 'which index to use')
          .action((queries, options) -> {
            var index =  (options.index != null)?options.index:'_all';
            var opt = {
              url: 'http://${program.host}:${program.port}/${index}/_search',
              json: program.json,
              qs: {
                q: queries.join(' ')
              }
            };
            var r = Request.construct();
            r.get(opt, handleResponse);
          });


        program.parse(process.argv);
    }
}