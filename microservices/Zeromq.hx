import js.node.buffer.Buffer;
import js.node.events.EventEmitter;

@:jsRequire('zeromq', 'Socket')
extern class Socket extends EventEmitter<Socket> {
    public function new(t :String);
    public function send(b :Buffer) :Void;
    public function bind(a :String) :Void;
    public function subscribe(a :String) :Void;
    public function connect(a :String) :Void;
}