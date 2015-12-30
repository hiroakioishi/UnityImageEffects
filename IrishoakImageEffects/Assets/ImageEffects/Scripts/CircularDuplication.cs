using UnityEngine;
using System.Collections;

namespace irishoak.ImageEffects {

	[ExecuteInEditMode]
	public class CircularDuplication : MonoBehaviour {

		[SerializeField]
		Shader   _shader;

		#region Params
		[SerializeField, Range (1, 24)]
		float _duplicateNum;
		public float DuplicateNum {
			set {
				_duplicateNum = value;
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
			_m.SetFloat ("_Value", _duplicateNum);

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