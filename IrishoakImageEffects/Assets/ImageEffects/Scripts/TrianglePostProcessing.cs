using UnityEngine;
using System.Collections;

namespace irishoak.ImageEffects {

	[ExecuteInEditMode]
	public class TrianglePostProcessing : MonoBehaviour {

		[SerializeField]
		Shader   _shader;

		#region Params
		[SerializeField, Range (1.0f, 100.0f)]
		float _cellSize;
		public float CellSize {
			set {
				_cellSize = value;
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

			_m.SetFloat ("_Value", _cellSize);
			_m.SetFloat ("_ScreenAspectRatio", Screen.width * 1.0f / Screen.height * 1.0f);

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