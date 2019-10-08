import js.lib.Error;
import js.node.buffer.Buffer;
import js.node.Fs;
import js.Node.process;

class ZmqFilerRep {
    static function main() {
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
        responder.bind("tcp://*:60401");
    }
}