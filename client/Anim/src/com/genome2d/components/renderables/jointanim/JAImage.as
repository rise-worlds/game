// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.jointanim.JAImage

package com.genome2d.components.renderables.jointanim
{
    import __AS3__.vec.Vector;
    import com.genome2d.components.renderables.jointanim.JAMemoryImage;

    public class JAImage 
    {

        public var drawMode:int;
        public var cols:int;
        public var rows:int;
        public var origWidth:int;
        public var origHeight:int;
        public var _transform:JATransform;
        public var imageName:String;
        public var images:Vector.<JAMemoryImage>;

        public function JAImage()
        {
            imageName = "";
            _transform = new JATransform();
            images = new Vector.<JAMemoryImage>();
        }

        public function get transform():JATransform
        {
            return (_transform);
        }

        public function OnMemoryImageLoadCompleted(image:JAMemoryImage):void
        {
            if ((((this.images.length == 1)) && ((this.images[0] == image))))
            {
                if (((!((this.origWidth == -1))) && (!((this.origHeight == -1)))))
                {
                    this._transform.matrix.m02 = (this._transform.matrix.m02 + (-((image.width - (this.origWidth * 1))) / (image.numCols + 1)));
                    this._transform.matrix.m12 = (this._transform.matrix.m12 + (-((image.height - (this.origHeight * 1))) / (image.numRows + 1)));
                };
            };
        }


    }
}//package com.flengine.components.renderables.jointanim

