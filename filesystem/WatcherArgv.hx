import js.node.Fs;
import js.lib.Error;
class WatcherArgv {
    static function main() {
        var args = Sys.args();
        if (args.length == 0) {
            throw new Error('A file to watch must be specified!');
        }
        var filename = args[0];
        Fs.watch(filename, (e, p)-> trace('${e} ${p}'));
        trace('Now watching ${filename} for changes...');
    }
}