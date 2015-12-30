using UnityEngine;
using System.Collections;

namespace irishoak.ImageEffects {

	[ExecuteInEditMode]
	public class CelShaderish : MonoBehaviour {

		[SerializeField]
		Shader   _shader;

		#region Params
		[SerializeField, Range (0.0f, 1.0f)]
		float _threshold = 0.2f;
		public float Threshold {
			set {
				_threshold = value;
			}
		}
		[SerializeField]
		Color _edgeColor;
		public Color EdgeColor {
			set {
				_edgeColor = value;
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

			_m.SetVector ("_ScreenResolution", new Vector2 (Screen.width, Screen.height));
			_m.SetVector ("_InvScreenResolution", new Vector2 (1.0f/Screen.width * 1.0f, 1.0f/Screen.height * 1.0f));
			_m.SetColor ("_EdgeColor", _edgeColor);
			_m.SetFloat ("_Threshold", _threshold);

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