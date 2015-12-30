using UnityEngine;
using System.Collections;

namespace irishoak.ImageEffects {

	[ExecuteInEditMode]
	public class NoiseFilter : MonoBehaviour {

		[SerializeField]
		Shader   _shader;

		#region Params
		[SerializeField, Range (0.0f, 10.0f)]
		float _strength;
		public float Strength {
			set {
				_strength = value;
			}
		}
		[SerializeField, Range (0.0f, 10.0f)]
		float _density;
		public float Density {
			set {
				_density = value;
			}
		}
		[SerializeField, Range (0.0f, 10.0f)]
		public float _speed;
		public float Speed {
			set {
				_speed = value;
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

			Shader.SetGlobalFloat ("_ScreenAspectRatio", Screen.width * 1.0f / Screen.height * 1.0f);

			_m.SetVector ("_Params", new Vector3 (_strength, _density, _speed));

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