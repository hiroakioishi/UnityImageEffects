using UnityEngine;
using System.Collections;

namespace irishoak.ImageEffects {

	[ExecuteInEditMode]
	public class Knitted : MonoBehaviour {

		[SerializeField]
		Shader   _shader;

		#region Params
		[SerializeField, Range (1, 12)]
		int _threads = 4;
		public int Threads {
			set {
				_threads = value;
			}
		}
		[SerializeField]
		Vector2 _tileSize = new Vector2 (0.05f, 0.05f);
		public Vector2 TileSize {
			set {
				_tileSize = value;
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

			_m.SetInt    ("_Threads",  _threads);
			_m.SetVector ("_TileSize", _tileSize);

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