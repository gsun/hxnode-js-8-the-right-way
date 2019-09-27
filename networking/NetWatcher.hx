import js.node.Fs;
import js.node.Net;
import js.Node.process;
import js.lib.Error;
class NetWatcher {
    static function main() {
        var args = Sys.args();
        if (args.length == 0) {
            throw new Error('Error: No filename specified.');
        }
        var filename = args[0];
        Net.createServer((connection) -> {
            trace('Subscriber connected.');
            connection.write('Now watching "${filename}" for changes...\n');
            var watcher = Fs.watch(filename, (e, p) -> {
                connection.write('File changed: ${Date.now().toString()}\n');
            });
            connection.on('close', () -> {
                trace('Subscriber disconnected.');
                watcher.close();
            });
        }).listen(60300, () -> trace('Listening for subscribers...'));
    }
}