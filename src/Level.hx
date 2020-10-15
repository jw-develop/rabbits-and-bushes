import Board;
import Node.NodeState;

class Level extends dn.Process {
	public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var fx(get,never) : Fx; inline function get_fx() return Game.ME.fx;

	public var wid(get,never) : Int; inline function get_wid() return 32;
	public var hei(get,never) : Int; inline function get_hei() return 32;

	public var b: Board;
	private var g: h2d.Graphics;

	var invalidated = true;

	public function new() {
		super(Game.ME);
		createRootInLayers(Game.ME.scroller, Const.DP_BG);

	}

	public inline function isValid(cx,cy) return cx>=0 && cx<wid && cy>=0 && cy<hei;
	public inline function coordId(cx,cy) return cx + cy*wid;


	public function render() {
		root.removeChildren();
		this.g = new h2d.Graphics(root);

		b = new Board(32,32);

	}

	override function fixedUpdate() {
		super.fixedUpdate();

		// Draw the board.
		if (b != null) {
			b.update();
			var start = b.start;
			var end = b.end;
			for (row in b.g) {
				for (node in row) {
					var color: Int;
					switch node.state {
						case NodeState.Undiscovered:
							if ((node.x + node.y) % 2 == 0) {
								color = 0xFFFFFF;
							} else {
								color = 0xFFFFFF; // color = 0x777777;
							}
						case NodeState.Open: color = 0x00FF00;
						case NodeState.Closed: color = 0xFF0000;
						case NodeState.Impassable: color = 0;
						case NodeState.Tracing: color = 0x0000FF;
					}

					if (node.x == start.x && node.y == start.y) color = 0x00FF00;
					if (node.x == end.x && node.y == end.y) color = 0x0000FF;

					g.beginFill(color);
					g.drawRect(node.x*Const.GRID - wid / 2, node.y*Const.GRID - hei / 2, Const.GRID, Const.GRID);
				}
			}
		}
	}

	override function postUpdate() {
		super.postUpdate();

		if( invalidated ) {
			invalidated = false;
			render();
		}
	}
}