using UnityEngine;
using System.Collections;

namespace irishoak.ImageEffects {

	[ExecuteInEditMode]
	public class RGBDisplay : MonoBehaviour {

		[SerializeField]
		Shader   _shader;

		#region Params
		[SerializeField, Range (1, 50)]
		int _cellSize;
		public int CellSize {
			set {
				this._cellSize = value;
			}
		}
		[SerializeField]
		Color _intervalColor;
		public Color IntervalColor {
			set {
				this._intervalColor = value;
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

			_m.SetInt    ("_CellSize", _cellSize * 3);
			_m.SetVector ("_ScreenResolution", new Vector2 (Screen.width, Screen.height));
			_m.SetColor  ("_IntervalColor", _intervalColor);

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