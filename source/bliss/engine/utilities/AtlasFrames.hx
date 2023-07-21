package bliss.engine.utilities;

import bliss.backend.Debug;
import sys.io.File;
import sys.FileSystem;
import haxe.xml.Access;
import bliss.backend.graphics.BlissGraphic;

typedef FrameData = {
	var name:String;
	var x:Float;
	var y:Float;
	var frameX:Float;
	var frameY:Float;
    var width:Int;
	var height:Int;
}

class AtlasFrames {
	/**
	 * The graphic attached to this atlas.
	 */
	public var graphic:BlissGraphic;

	/**
	 * A list of frame data.
	 */
	public var frames:Array<FrameData> = [];

	/**
	 * The amount of frames in this atlas.
	 */
	public var numFrames(get, never):Int;

    /**
	 * Generates an atlas frame collection from a single graphic.
     * 
     * @param graphic  The graphic to attach to the new atlas.
     * @param xml      The XML to parse for frame data like positioning and sizing.
     *                 This can be a path or raw XML data.
	 */
	public static function fromGraphic(graphic:BlissGraphicAsset) {
		var atlas = new AtlasFrames();
		if(graphic is BlissGraphic)
			atlas.graphic = graphic;
		else
			atlas.graphic = BlissGraphic.fromFile(cast graphic);

        atlas.frames.push({
            name: "#__GRAPHIC__",
            x: 0,
            y: 0,
            width: atlas.graphic.width,
            height: atlas.graphic.height,
            frameX: 0,
            frameY: 0,
        });
        return atlas;
    }

	/**
	 * Generates an atlas frame collection from a graphic and xml data.
     * 
     * @param graphic  The graphic to attach to the new atlas.
     * @param xml      The XML to parse for frame data like positioning and sizing.
     *                 This can be a path or raw XML data.
	 */
	public static function fromSparrow(graphic:BlissGraphicAsset, xml:String) {
        var xmlData:Xml = null;
        try {
            if(FileSystem.exists(xml))
                xmlData = Xml.parse(File.getContent(xml));
            else
                xmlData = Xml.parse(xml);
        } catch(e) {
            xmlData = null;
            Debug.log(ERROR, 'Sparrow XML failed to load! - $e');
        }

        try {
            final atlas = new AtlasFrames();
            if(graphic is BlissGraphic)
                atlas.graphic = graphic;
            else
                atlas.graphic = BlissGraphic.fromFile(cast graphic);

            final atlasData:Access = new Access(xmlData.firstElement());

            for(frame in atlasData.nodes.SubTexture) {
                atlas.frames.push({
                    name: frame.att.name,
                    x: Std.parseFloat(frame.att.x),
                    y: Std.parseFloat(frame.att.y),
                    width: Std.parseInt(frame.att.width),
                    height: Std.parseInt(frame.att.height),
                    frameX: frame.has.frameX ? Std.parseFloat(frame.att.frameX) : 0,
                    frameY: frame.has.frameY ? Std.parseFloat(frame.att.frameY) : 0,
                });
            }
            return atlas;
        } catch(e) {
            Debug.log(ERROR, 'Sparrow atlas failed to load! - $e');
        }
		return fromGraphic(graphic);
	}

	// ##-- VARIABLES/FUNCTIONS YOU SHOULDN'T TOUCH!! --##//

	/**
	 * Used internally, please use static methods instead.
	 */
	@:noCompletion
	public function new() {}

	@:noCompletion
	private function get_numFrames():Int {
		return frames.length;
	}
}
