// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.error.FError

package com.flengine.error
{
    public class FError extends Error 
    {

        public static const UNKNOWN:String = "FError: Unknow FlEngine error, probably after using some undocumented feature ;)";
        public static const GENOME2D_NOT_INITIALIZED:String = "FError: FlEngine is not initialized.";
        public static const CANNOT_INITIALIZE_CONTEXT3D:String = "FError: Cannot initialize Context3D.";
        public static const MULTIPLE_RENDERABLES:String = "FError: Node cannot have multiple renderable components.";
        public static const CHILD_OF_ITSELF:String = "FError: Node cannot be the child of itself.";
        public static const NOT_A_CHILD_OF_NODE:String = "FError: Specified child is not a child of this node.";
        public static const MULTIPLE_BODIES:String = "FError: Node cannot have multiple body components.";
        public static const NULL_PROTOTYPE:String = "FError: Prototype cannot be null.";
        public static const IS_SINGLETON:String = "FError: FlEngine is a singleton and cannot be instantiated directly use getInstance instead.";
        public static const NULL_BITMAPDATA:String = "FError: BitmapData cannot be null.";
        public static const INVALID_TEXTURE_ID:String = "FError: Texture ID cannot be null or empty.";
        public static const DUPLICATE_TEXTURE_ID:String = "FError: Texture with specified ID already exists.";
        public static const INVALID_SOURCE:String = "FError: Invalid texture source used.";
        public static const INVALID_ATLAS_SIZE:String = "FError: Invalid atlas size, it needs to be power of 2.";
        public static const TEXTURE_ID_DOESNT_EXIST:String = "FError: Texture ID doesn't exist.";
        public static const INVALID_ATF_DATA:String = "FError: Invalid ATF data.";
        public static const INVALID_RENDERABLE_CLASS:String = "FError: Invalid renderable class.";
        public static const INVALID_RESAMPLE_TYPE:String = "FError: Invalid resample type.";
        public static const INVALID_FILTERING_TYPE:String = "FError: Invalid filtering type.";
        public static const CANNOT_INSTANTATE_ABSTRACT:String = "FError: Cannot instantiate abstract class.";
        public static const INVALID_PARTICLE_COMPONENT_FOUND:String = "FError: Invalid or no particle component found.";
        public static const INVALID_COMPONENT_CLASS:String = "FError: Invalid component class.";
        public static const NODE_ALREADY_DISPOSED:String = "FError: Node is already disposed.";
        public static const NO_TEXTURE_FOR_CHARACTER_FOUND:String = "FError: Texture doesn't exist for character ";
        public static const NO_PHYSICS_INITIALIZED:String = "FError: There is no physics initialized.";
        public static const TEXTURE_REGION_CANNOT_BE_SET:String = "FError: Only subtextures can have their region set.";
        public static const CANNOT_DO_WHILE_RENDER:String = "FError: Cannot do this while rendering.";
        public static const CAMERA_NOT_PRESENT:String = "FError: Camera is not present inside render graph.";
        public static const INVALID_CAMERA_INDEX:String = "FError: Camera index is outside of valid index range.";
        public static const ATLEAST_ONE_PASS_REQUIRED:String = "FError: Post process needs atleast one pass.";
        public static const CANNOT_RUN_IN_CONSTRAINED:String = "FError: Cannot run in constrained mode.";

        public function FError(message:String, argument:Object=null)
        {
            super((message + ((argument) ? (" Param: " + argument) : "")), 0);
        }

    }
}//package com.flengine.error

