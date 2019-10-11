import js.Node.process;
import js.Node.console;
import js.npm.Commander.root as program;
import js.npm.elasticsearch.Client;

class Esclu {
    static function main() {
        program
          .version('1.0.0')
          .description('Elasticsearch Command Line Utilities')
          .usage('[options] <command> [...]')
          .option('-o, --host <hostname>', 'hostname [localhost]', 'localhost')
          .option('-p, --port <number>', 'port number [9200]', '9200')
          .option('-j, --json', 'format output as JSON')
          .option('-i, --index <name>', 'which index to use')
          .option('-t, --type <type>', 'default type for bulk operations');

        program
          // Other options...
          .option('-f, --filter <filter>', 'source filter for query results');

        program
          .command('ping')
          .description('ping the elasticsearch server')
          .action(() -> {
                var client = new Client({
                  host: '${program.host}:${program.port}',
                  log: 'trace'
                });

                client.ping({
                  requestTimeout: Math.POSITIVE_INFINITY,
                }, function(error, result) {
                  if (error != null) {
                    console.log('elasticsearch cluster is down');
                  } else {
                    console.log('All is well, ${result}');
                  }
                });
          });

        program
          .command('get [path]')
          .description('perform an HTTP GET request for path (default is /)')
          .action((path='/') -> {

          });

        program
          .command('create-index')
          .description('create an index')
          .action(() -> {
          });

        program
          .command('list-indices')
          .alias('li')
          .description('get a list of indices in this cluster')
          .action(() -> {
          });

        program
          .command('delete-index')
          .description('delete an index')
          .action(() -> {
          });

        program
          .command('bulk <file>')
          .description('read and perform bulk options from the specified file')
          .action((file) -> {
          });

        program
          .command('query [queries...]')
          .alias('q')
          .description('perform an Elasticsearch query')
          .action((queries) -> {
          });


        program.parse(process.argv);
    }
}