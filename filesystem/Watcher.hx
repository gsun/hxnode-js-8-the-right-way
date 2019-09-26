import js.node.Fs;
class Watcher {
    static function main() {
        Fs.watch('target.txt', (e, p)-> trace('${e} ${p}'));
        trace('Now watching target.txt for changes...');
    }
}