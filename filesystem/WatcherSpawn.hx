import js.node.Fs;
import js.lib.Error;
import js.node.ChildProcess.spawn;
import js.Node.process;
class WatcherSpawn {
    static function main() {
        var args = Sys.args();
        if (args.length == 0) {
            throw new Error('A file to watch must be specified!');
        }
        var filename = args[0];
        Fs.watch(filename, (e, p)-> {
            var ls = spawn('ls', ['-l', '-h', filename]);
            ls.stdout.pipe(process.stdout);
        });
        trace('Now watching ${filename} for changes...');
    }
}