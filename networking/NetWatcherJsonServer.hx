import js.node.Fs;
import js.node.Net;
import js.Node.process;
import js.lib.Error;
class NetWatcherJsonServer {
    static function main() {
        var args = Sys.args();
        if (args.length == 0) {
            throw new Error('Error: No filename specified.');
        }
        var filename = args[0];
        Net.createServer((connection) -> {
            trace('Subscriber connected.');
            connection.write(haxe.Json.stringify({type: 'watching', file: filename}) + '\n');
            var watcher = Fs.watch(filename, (e, p) -> {
                connection.write(haxe.Json.stringify({type: 'changed', timestamp: Date.now()}) + '\n');
            });
            connection.on('close', () -> {
                trace('Subscriber disconnected.');
                watcher.close();
            });
        }).listen(60300, () -> trace('Listening for subscribers...'));
    }
}