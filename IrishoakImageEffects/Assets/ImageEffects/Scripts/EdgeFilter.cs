using UnityEngine;
using System.Collections;

namespace irishoak.ImageEffects {

	[ExecuteInEditMode]
	public class EdgeFilter : MonoBehaviour {

		[SerializeField]
		Shader   _shader;

		#region Params
		[SerializeField, Range (0.0f, 10.0f)]
		float _amplifer;
		public float Amplifer {
			set {
				_amplifer = value;
			}
		}
		[SerializeField]
		Color _edgeColor;
		public Color EdgeColor {
			set {
				_edgeColor = value;
			}
		}
		public 
		#endregion

		Material _m;

		void OnRenderImage (RenderTexture source, RenderTexture destination)
		{
			if (_m == null) {
				_m = new Material (_shader);
				_m.hideFlags = HideFlags.DontSave;
			}

			_m.SetFloat ("_Amplifer",  _amplifer );
			_m.SetColor ("_EdgeColor", _edgeColor);

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