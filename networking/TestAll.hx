import utest.Assert;
import js.node.events.EventEmitter;

class Dummy extends EventEmitter<Dummy> {
}

class TestCase1 extends utest.Test {
  var stream :Dummy;
  var client :LdjClient;

  //synchronous setup
  public function setup() {
    stream = new Dummy();
    client = new LdjClient(stream);
    client.on('message', (message) -> {
      Assert.same(message, {foo: 'bar'});
    });
  }

  function testFieldIsSome() {
    var message = haxe.Json.stringify({foo: "bar"}) + '\n';
    stream.emit('data', message);
  }
  
  @:timeout(1000)
  public function teardown() {
  }

}

class TestAll {
  public static function main() {
    utest.UTest.run([new TestCase1()]);
  }
}