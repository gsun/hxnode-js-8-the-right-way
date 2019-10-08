import js.lib.Error;
import js.node.buffer.Buffer;
import js.node.Fs;
import js.Node.process;
import js.node.Cluster.instance as cluster;
import js.node.cluster.Worker;
import js.node.Os;

class ZmqFilerRepCluster {
    static function main() {
        var numWorkers = Os.cpus().length;
        
        if (cluster.isMaster) {
            // Master process creates ROUTER and DEALER sockets and binds endpoints.
            var router = new Zeromq.Socket('router'); 
            var dealer = new Zeromq.Socket('dealer'); 
            
            router.bind('tcp://*:60401');
            dealer.bind('ipc://filer-dealer.ipc');

            // Forward messages between the router and dealer.
            router.on('message', untyped __js__('(...frames) => dealer.send(frames)'));
            dealer.on('message', untyped __js__('(...frames) => router.send(frames)'));

            // Listen for workers to come online.
            cluster.on('online', (worker) -> trace('Worker ${worker.process.pid} is online.'));

            // Fork a worker process for each CPU.
            for (ii in 0...numWorkers) {
                cluster.fork();
            }
            
        } else {
        }
        var responder = new Zeromq.Socket('rep');
        responder.on('message', (data) -> {
            var request = haxe.Json.parse(data);
            trace('Received request to get: ${request.path}');
            Fs.readFile(request.path, (err, content) -> {
                trace('Sending response content.');
                var message = haxe.Json.stringify({content:content.toString(), timestamp:Date.now(), pid:process.pid});
                responder.send(Buffer.from(message, 'utf8'));
            });
        });
        responder.connect('ipc://filer-dealer.ipc');
    }
}