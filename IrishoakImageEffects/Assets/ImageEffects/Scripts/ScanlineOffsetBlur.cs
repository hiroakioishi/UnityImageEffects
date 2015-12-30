using UnityEngine;
using System.Collections;

namespace irishoak.ImageEffects {

	[ExecuteInEditMode]
	public class ScanlineOffsetBlur : MonoBehaviour {

		[SerializeField]
		Shader   _shader;

		#region Params
		[SerializeField, Range (1, 1080)]
		int _scanLineNum = 1080;
		public int ScanLineNum {
			set {
				_scanLineNum = value;
			}
		}
		[SerializeField, Range (0.0f, 1.0f)]
		float _offset = 0.008f;
		public float Offset {
			get {
				return this._offset;
			}
			set {
				this._offset = value;
			}
		}
		#endregion

		Material _m;

		void OnRenderImage (RenderTexture source, RenderTexture destination)
		{
			if (_m == null) {
				_m = new Material (_shader);
				_m.hideFlags = HideFlags.DontSave;
			}

			_m.SetInt ("_ScanLineNum", _scanLineNum);
			_m.SetFloat ("_Offset", _offset);

			Graphics.Blit (source, destination, _m);
		}

		void OnDestroy ()
		{
			if (_m != null) {
				DestroyImmediate (_m);
			}
		}
	}
}