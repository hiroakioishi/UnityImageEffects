using UnityEngine;
using System.Collections;

namespace irishoak.ImageEffects {

	[ExecuteInEditMode]
	public class CameraRectAdjuster : MonoBehaviour {

		[SerializeField, Range (1, 16)]
		int _divNumX = 1;
		[SerializeField, Range (1, 16)]
		int _divNumY = 1;
		[SerializeField, Range (0, 15)]
		int _divX = 0;
		[SerializeField, Range (0, 15)]
		int _divY = 0;

		void Update () {

			GetComponent <Camera> ().rect = new Rect ((1.0f/_divNumX) * _divX, 1.0f - (1.0f/_divNumY) * (_divY+1), 1.0f/_divNumX, 1.0f/_divNumY);

		}

		void OnGUI () {
			GUI.Label (
				new Rect(
				(Screen.width / _divNumX) * _divX, (Screen.height / _divNumY) * _divY, 128, 128), gameObject.name);
		}
	}

}