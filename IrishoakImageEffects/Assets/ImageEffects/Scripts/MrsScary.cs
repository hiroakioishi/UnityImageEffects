using UnityEngine;
using System.Collections;

namespace irishoak.ImageEffects {

	[ExecuteInEditMode]
	public class MrsScary : MonoBehaviour {

		[SerializeField]
		Shader   _shader;

		#region Params
		[SerializeField, Range (0.0f, 1.0f)]
		float _rotation;
		#endregion

		Material _m;

		void OnRenderImage (RenderTexture source, RenderTexture destination)
		{
			if (_m == null) {
				_m = new Material (_shader);
				_m.hideFlags = HideFlags.DontSave;
			}

			_m.SetFloat ("_Rotation", _rotation);

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