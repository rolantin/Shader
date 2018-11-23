using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

public class CatchDeltaDepth  {


	//将RenderTexture保存成一张png图片  
	public static bool  SaveRenderTextureToPNG(RenderTexture rt, string path)
	{
		RenderTexture prev = RenderTexture.active;
		RenderTexture.active = rt;
		Texture2D png = new Texture2D(rt.width, rt.height, TextureFormat.ARGB32, false);
		png.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
		byte[] bytes = png.EncodeToPNG();
	
		FileStream file = File.Open(path, FileMode.Create);
		BinaryWriter writer = new BinaryWriter(file);
		writer.Write(bytes);
		file.Close();
		Texture2D.DestroyImmediate(png);
		png = null;
		RenderTexture.active = prev;
		return true;

	}
 
	[MenuItem("TA/捕捉深度差图")]
	private static void catchDeltaDepth()
	{
		var obj = Selection.activeGameObject;
		MeshFilter mesh = obj.GetComponent<MeshFilter> ();
		if (mesh !=  null) {
			Renderer _render = obj.GetComponent<Renderer> ();
			Vector3 [] vectors = mesh.sharedMesh.vertices;


			GameObject CameraObj = new GameObject("myCamera");
	        Camera cam = CameraObj.AddComponent<Camera>();
			cam.transform.parent = obj.transform;
			cam.transform.localPosition = new Vector3(0,5,0);
			cam.transform.localScale = Vector3.one;
			cam.transform.localRotation = Quaternion.Euler (90, 0, 0);
	        //cam.depth = ;
	        //cam.cullingMask = 1 << CAM_LAYER;
	       // cam.gameObject.layer = CAM_LAYER;
			cam.clearFlags = CameraClearFlags.SolidColor;
	        
	        cam.orthographic = true;        //投射方式：orthographic正交//
	        cam.orthographicSize = 1;       //投射区域大小//
	        cam.nearClipPlane = 0.01f;      //前距离//
	        cam.farClipPlane = 10;       //后距离//
	        cam.rect = new Rect(0, 0, 1f, 1f);

			cam.transform.parent = null;
			cam.transform.localScale = Vector3.one;
			float maxX = 0.0f;
			float maxY = 0.0f;
			for (int i = 0, len = vectors.Length; i < len; i++) {
				Vector3 w = obj.transform.localToWorldMatrix.MultiplyPoint (vectors [i]);
				 
				Vector3 l = cam.transform.worldToLocalMatrix.MultiplyPoint (w);
				maxX = Mathf.Max (Mathf.Abs(l.x),maxX);
				maxY = Mathf.Max (Mathf.Abs(l.y),maxY);
			}
			cam.orthographicSize = maxY;
			cam.aspect = maxX / maxY;


			var path = EditorUtility.SaveFilePanel(
				"Save texture as PNG",
				"",
				obj.name+"_depth.png",
				"png");

			if (path.Length != 0)
			{
				var m = new Material (Shader.Find("Rolan/WriteDepthToRT2"));
				var old = _render.sharedMaterial;
				_render.sharedMaterial = m;
				RenderTexture tex = new RenderTexture ((int)maxY * 100, (int)maxY * 100, 16, RenderTextureFormat.ARGB32);
				RenderTexture tex2 = new RenderTexture (tex.width, tex.height, 0, RenderTextureFormat.ARGB32);

				RenderTexture.active = tex2;
				GL.Clear (false, true, Color.red, 0);

				RenderBuffer [] buff = new RenderBuffer[]{tex.colorBuffer,tex2.colorBuffer};
				cam.SetTargetBuffers (buff, tex.depthBuffer);
				cam.depthTextureMode |= DepthTextureMode.Depth;        
		 
				//cam.depthTextureMode = DepthTextureMode.Depth;
				cam.Render();
				cam.Render();
				SaveRenderTextureToPNG (tex,path+"1.png");
				SaveRenderTextureToPNG (tex2,path);
				cam.targetTexture = null;
				GameObject.DestroyImmediate (CameraObj);
				GameObject.DestroyImmediate (tex);
				GameObject.DestroyImmediate (tex2);
				_render.sharedMaterial = old;
				GameObject.DestroyImmediate (m);
				return;
			}
			GameObject.DestroyImmediate (cam);

		 
		}
		else
		{
			EditorUtility.DisplayDialog("提示","请选择一个panel", "确定" );
		}

	}
}
