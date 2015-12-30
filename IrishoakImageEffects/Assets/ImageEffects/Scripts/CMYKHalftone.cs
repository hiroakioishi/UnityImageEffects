using UnityEngine;
using System.Collections;

namespace irishoak.ImageEffects {

	[ExecuteInEditMode]
	public class CMYKHalftone : MonoBehaviour {

		[SerializeField]
		Shader   _shader;

		#region Params
		[SerializeField, Range (0.0f, 1.0f)]
		float _value   = 1.0f;
		[SerializeField, Range (0.1f, 10.0f)]
		float _dotSize = 4.0f;
		public float DotSize {
			set {
				_dotSize = value;
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

			_m.SetFloat ("_Value", _value);
			_m.SetFloat ("_DotSize", 1.0f/_dotSize);
			_m.SetVector ("_ScreenResolution", new Vector2 (Screen.width, Screen.height));

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