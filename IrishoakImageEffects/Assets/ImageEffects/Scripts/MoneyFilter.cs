using UnityEngine;
using System.Collections;

namespace irishoak.ImageEffects {

	[ExecuteInEditMode]
	public class MoneyFilter : MonoBehaviour {

		[SerializeField]
		Shader   _shader;

		#region Params
		[SerializeField]
		float _frequency = 10f;
		public float Frequency {
			set {
				_frequency = value;
			}
		}
		[SerializeField, Range (0.001f, 0.01f)]
		float _divisor   = 0.0075f;
		public float Divisor {
			set {
				_divisor = value;
			}
		}
		[SerializeField]
		float _gain      = 1.0f;
		public float Gain {
			set {
				_gain = value;
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

			_m.SetFloat ("_Frecuencia", _frequency);
			_m.SetFloat ("_Divisor", _divisor);
			_m.SetFloat ("_Gain", _gain);

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