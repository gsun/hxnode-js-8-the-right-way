import js.node.Fs;
import js.lib.Error;
import js.node.ChildProcess.spawn;
import js.Node.process;
class WatcherSpawnParse {
    static function main() {
        var args = Sys.args();
        if (args.length == 0) {
            throw new Error('A file to watch must be specified!');
        }
        var filename = args[0];
        Fs.watch(filename, (e, p)-> {
            var ls = spawn('ls', ['-l', '-h', filename]);
            var output = '';
            ls.stdout.on('data', (chunk) -> output += chunk);
            ls.on('close', () -> {
                var parts = output.split(' ');
                trace([parts[0], parts[4], parts[8]]);
            });
        });
        trace('Now watching ${filename} for changes...');
    }
}