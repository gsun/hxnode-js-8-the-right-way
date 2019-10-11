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
          .option('-p, --port <number>', 'port number [9200]', '9200');

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
          .command('get <id>')
          .description('get an entry')
          .option('-i, --index <name>', 'which index to use')
          .option('-t, --type <type>', 'default type for bulk operations')
          .action((id, options) -> {
                if (options.index == null || options.type == null) {
                    console.error('no command given!');
                    process.exit(1);
                }
                var client = new Client({
                  host: '${program.host}:${program.port}',
                  log: 'trace'
                });
                client.get({
                    index: options.index,
                    type: options.type,
                    id: id
                }, function(error, result) {
                  if (error != null) {
                      console.log('elasticsearch cluster is down');
                  } else {
                      console.log(result);
                  }
                });
          });

        program
          .command('create-index <index>')
          .description('create an index')
          .action((index) -> {
                var client = new Client({
                  host: '${program.host}:${program.port}',
                  log: 'trace'
                });
                client.indices.create({
                    index: index,
                }, function(error, result) {
                  if (error != null) {
                      console.log('elasticsearch cluster is down');
                  } else {
                      console.log(result);
                  }
                });
          });

        program
          .command('list-indices')
          .alias('li')
          .description('get a list of indices in this cluster')
          .action(() -> {
                var client = new Client({
                  host: '${program.host}:${program.port}',
                  log: 'trace'
                });
                client.cat.indices({
                    format: 'json'
                }, function(error, result) {
                  if (error != null) {
                      console.log('elasticsearch cluster is down');
                  } else {
                      console.log(result);
                  }
                });
          });

        program
          .command('delete-index <index>')
          .description('delete an index')
          .action((index) -> {
                var client = new Client({
                  host: '${program.host}:${program.port}',
                  log: 'trace'
                });
                client.indices.delete({
                    index: index,
                }, function(error, result) {
                  if (error != null) {
                      console.log('elasticsearch cluster is down');
                  } else {
                      console.log(result);
                  }
                });
          });

        program
          .command('bulk <file>')
          .description('read and perform bulk options from the specified file')
          .action((file) -> {
                console.log('file ${file}');
          });

        program
          .command('query [queries...]')
          .alias('q')
          .description('perform an Elasticsearch query')
          .option('-i, --index <name>', 'which index to use')
          .action((queries, options) -> {
                if (queries == null) {
                    console.error('no queries given!');
                    process.exit(1);
                }
                var client = new Client({
                  host: '${program.host}:${program.port}',
                  log: 'trace'
                });
                client.search({
                    index: options.index=null?'_all':options.index,
                    q: queries.join(' ')
                }, function(error, result) {
                  if (error != null) {
                      console.log('elasticsearch cluster is down');
                  } else {
                      console.log(result);
                  }
                });
          });


        program.parse(process.argv);
    }
}