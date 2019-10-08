import js.lib.Error;
import js.node.Fs;
import js.node.buffer.Buffer;

class ZmqFilerReqLoop {
    static function main() {
        var args = Sys.args();
        if (args.length == 0) {
            throw new Error('Error: No filename specified.');
        }
        var filename = args[0];
        var requester = new Zeromq.Socket('req');
        requester.on('message', (data) -> {
            var response = haxe.Json.parse(data);
            trace('Received response: ${data}');
        });
        requester.connect('tcp://localhost:60401');
        for (ii in 1...6) {
            trace('Sending a request ${ii} for ${filename}');
            var message = haxe.Json.stringify({ path: filename });
            requester.send(Buffer.from(message, 'utf8'));
        }
    }
}