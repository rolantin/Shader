using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;


public class MeshToHightMap : EditorWindow {
	public Mesh mesh;
	public float maxx = float.MinValue;
	public float maxy = float.MinValue;
	public float maxz = float.MinValue;
	public float minx = float.MaxValue;
	public float miny = float.MaxValue;
	public float minz = float.MaxValue;

	public Bounds bounds;
	public Material mat;
	private int index = 1;
	public string[] options = new string[] {"256", "512", "1024","2048"};
	GameObject sel;
	// Use this for initialization

	[MenuItem("TA/Mesh To HeightMap")]
	static void MeshToHightMapFun () {
		
		GameObject g =  Selection.activeObject as GameObject;
		if (null == g)
			return;
		MeshFilter m = g.GetComponent<MeshFilter> ();
		if (null == m)
			return;


		Mesh mesh = m.sharedMesh;

		MeshToHightMap window = (MeshToHightMap)EditorWindow.GetWindow(typeof(MeshToHightMap));
		window.mesh = mesh;
		window.mat = m.GetComponent<MeshRenderer> ().sharedMaterial;
		window.Show ();

		Vector3 center;
		Vector3 size ;
		Vector3 [] points = mesh.vertices;

		for (int i = 0; i < points.Length; i++) {
			Vector3 v =  points [i];
			window.maxx = Mathf.Max (v.x, window.maxx);
			window.maxy = Mathf.Max (v.y, window.maxy);
			window.maxz = Mathf.Max (v.z, window.maxz);
			window.minx = Mathf.Min (v.x, window.minx);
			window.miny = Mathf.Min (v.y, window.miny);
			window.minz = Mathf.Min (v.z, window.minz);
		}
		center = new Vector3 (0 , 0,0 );
		int sizex = (int)(Mathf.Max (Mathf.Abs (window.maxx), Mathf.Abs (window.minx))*2 +2f);
		int sizey = (int)(Mathf.Max (Mathf.Abs (window.maxy), Mathf.Abs (window.miny))*2 + 2f);
		int sizez = (int)(Mathf.Max (Mathf.Abs (window.maxz), Mathf.Abs (window.minz))*2 + 2f);
		sizex = (int)Mathf.Max (sizex, sizey);//偷懶.
		sizey = sizex;
		size =  new Vector3( sizex , sizey, sizez ); 
		window.bounds = new Bounds (center, size);
		//EditorUtility.DisplayDialog ("title", g.name, "确认", "取消");
		window.sel = g;
	}

	/*float4 EncodeFloatRGBA( float v )
	{
		float4 kEncodeMul = float4(1.0, 255.0, 65025.0, 16581375.0);
		float kEncodeBit = 1.0/255.0;
		float4 enc = kEncodeMul * v;
		enc = frac (enc);
		enc -= enc.yzww * kEncodeBit;
		return enc;
	}*/

	float frac(float v)
	{
		return v - (int)v;
	}
	Vector4 frac(Vector4 v)
	{
		return new Vector4 (frac(v.x),frac(v.y),frac(v.z),frac(v.w));
	}
	/*inline float4 EncodeFloatRGBA( float v ){
			float4 kEncodeMul = float4(1.0, 255.0, 65025.0, 16581375.0);
			float kEncodeBit = 1.0/255.0;
			float4 enc = kEncodeMul * v;
			enc = frac (enc);
			enc -= enc.yzww * kEncodeBit;
			return enc;
		}*/

	/*inline float DecodeFloatRGBA( float4 enc )
	{
		float4 kDecodeDot = float4(1.0, 1/255.0, 1/65025.0, 1/16581375.0);
		return dot( enc, kDecodeDot );
	}
	*/
	Color EncodeFloatRGBA( float v )
	{
		Vector4 kEncodeMul = new Vector4(1.0f, 255.0f, 65025.0f, 16581375.0f);
		float kEncodeBit = 1.0f/255.0f;
		Vector4 enc = kEncodeMul * v;
		enc = frac (enc);
		enc -= new Vector4(enc.y,enc.z,enc.w,enc.w)* kEncodeBit;
		return new Color(enc.x,enc.y,enc.z,enc.w);
	}

	float DecodeFloatRGBA( Color enc )
	{
		Vector4 kDecodeDot = new Vector4(1.0f, 1f/255.0f, 1f/65025.0f, 1f/16581375.0f);
		return Vector4.Dot (  new Vector4(enc.r,enc.g,enc.g,enc.a)   ,kDecodeDot );
	}
	 
		
	void buildHightMap(string path)
	{

		GameObject g = new GameObject ();
		MeshCollider c = g.AddComponent<MeshCollider> ();
		c.sharedMesh = mesh;
		g.transform.position = Vector3.zero;
		g.transform.localScale = Vector3.one;
		g.transform.localRotation = Quaternion.Euler(new Vector3(-90,0,0));
		g.transform.position = new Vector3 (0, -minz,0);
		MeshFilter mf = g.AddComponent<MeshFilter> ();
		mf.sharedMesh = mesh;
		MeshRenderer mr = g.AddComponent<MeshRenderer> ();
		mr.sharedMaterial = mat;
		int pic_size = int.Parse(options[index]);//偷懶.
		Texture2D  t = new Texture2D(pic_size,pic_size,TextureFormat.ARGB32,false);
		t.wrapMode = TextureWrapMode.Clamp;
		t.filterMode = FilterMode.Point;
		float delta = bounds.size.x / pic_size;
		RaycastHit hit ;
		Ray r = new Ray ();
		float beginX = - bounds.size.x*0.5f;
		float beginZ = beginX;
		float RangeY = maxz - minz;
		float ray_range = RangeY+ 2;//扫描区域大一点，顺便避免除法0.
		r.direction = new Vector3(0,-1,0);

		for (int i = 0; i < pic_size; i++) {
			for(int j = 0 ; j < pic_size ; j++)
			{
				float height = 0.0f;
				r.origin = new Vector3(beginX + delta*i  ,  RangeY+1 ,      beginZ + delta*j  );
				if (c.Raycast (r, out hit, ray_range)) 
				{
					float y = hit.point.y ;//最低点已经在地平面了.
					height = y / ray_range ;
				} 
				Color e = EncodeFloatRGBA (height);
				float dec = DecodeFloatRGBA (e);

				//t.SetPixel (i, j,new Color(dec,dec,dec));
				t.SetPixel (i, j,new Color(height,height,height));
				//t.SetPixel(i,j ,e);
 
			}
		}
		Mesh _mesh = new Mesh ();
		_mesh.indexFormat = UnityEngine.Rendering.IndexFormat.UInt32;
		 
		//pic_size = 150;
		int col = pic_size + 1;
		delta =  bounds.size.x / pic_size;
		Vector3 [] _vec0 = new Vector3[ col*col ];
		Vector2[]  _uv0 = new Vector2[col*col];
		int[] _triangles0 = new int[pic_size*pic_size*6];
		for (int i = 0; i < col; i++) {
			for (int j = 0; j < col; j++) {
				_vec0 [i + j * col] = new Vector3 (beginX  + ( i) * delta , 0, beginX+ ( j ) * delta  );
				_uv0 [i + j * col] = new Vector2 (   ((float)i) / pic_size,  ((float)  j) / pic_size  );
			}
		}

		for (int i = 0; i < pic_size  ; i++) {
			for (int j = 0; j < pic_size  ; j++) {
				_triangles0 [(i + j * pic_size) * 6 + 0] = (i   ) + (j+1) * col ;
				_triangles0 [(i + j * pic_size) * 6 + 1] = (i+1) + ( j +1) * col ;
				_triangles0 [(i + j * pic_size) * 6 + 2] = (i+1) + ( j ) * col ;  
				_triangles0 [(i + j * pic_size) * 6 + 3] = (i   ) + (j+1) * col ;
				_triangles0 [(i + j * pic_size) * 6 + 4] = (i+1) + ( j ) * col ;
					_triangles0 [(i + j * pic_size) * 6 + 5] =  (i ) + ( j ) * col ;
			}
		}
		Vector3 []_vec = new Vector3[4];
		_vec [0] = new Vector3 (beginX,0,beginX); //-1,-1
		_vec [1] = new Vector3 (-beginX,0,beginX); //1,-1
		_vec [2] = new Vector3 (beginX,0,-beginX); //-1,1
		_vec [3] = new Vector3 (-beginX,0,-beginX); //1,1

 
		//Vector4[] _triangles0 = new Vector4[]{ Vector4.left,Vector4.left,Vector4.left,Vector3.left};
		Vector2[] _uv = new Vector2[4];
		_uv [0] = new Vector2 (0, 0);
		_uv [1] = new Vector2 (1, 0);
		_uv [2] = new Vector2 (0, 1);
		_uv [3] = new Vector2 (1, 1);

		int[] _triangles = { 0,3,1,0,2,3};

		/*
		_mesh.vertices = _vec;
		_mesh.uv = _uv;
		_mesh.triangles = _triangles;
		*/

		_mesh.vertices = _vec0;
		_mesh.uv = _uv0;
		_mesh.triangles = _triangles0;

 

		_mesh.RecalculateNormals();
		_mesh.RecalculateTangents ();

		var vs = _mesh.normals;
		var ts = _mesh.tangents;
		//_mesh.UploadMeshData (false);
		mf.sharedMesh = _mesh;

		Mesh mesh2 = new Mesh ();

		//GameObject.DestroyImmediate (c, true);
		Material newMat =  new Material (Shader.Find("Rolan/t4mh"));
		newMat.CopyPropertiesFromMaterial (mr.sharedMaterial);
		//不知道为毛线这里设置无效啊.
		//newMat.SetFloat ("minY", minz);
		//newMat.SetFloat("RangeY",ray_range);
		//newMat.SetFloat("maxX",beginX);
		//newMat.SetTexture ("_HeightMap", t);
 

		mr.sharedMaterial = newMat;
		mr.material = newMat;
		g.transform.localRotation = Quaternion.identity;
		//mf.mesh 
		RenderTexture renderTexture = new RenderTexture (pic_size, pic_size, 0, RenderTextureFormat.ARGB32);
		Graphics.Blit(t, renderTexture);



		string texturePath;
		texturePath = path.Substring (0, path.Length - 6) + "renderTexture";
 
		AssetDatabase.CreateAsset (renderTexture, texturePath);
		byte[] bytes = t.EncodeToPNG ();
		texturePath = path.Substring (0, path.Length - 6) + "png";
		FileStream file = File.Open(texturePath, FileMode.Create);
		BinaryWriter writer = new BinaryWriter(file);
		writer.Write(bytes);
		file.Close();
		//Texture2D.DestroyImmediate(t);
		//CreatePrefab
	
		Texture2D t2 = AssetDatabase.LoadAssetAtPath<Texture2D> (texturePath);
        //back
		//SetTextureAndSaveToDisk txt = g.AddComponent<SetTextureAndSaveToDisk> ();
		//txt.tex = t2;
		//txt.mat = newMat;
		//txt.minz = minz;
		//txt.ray_range = ray_range;
		//txt.beginX = beginX;
        //back
		//newMat.SetTexture ("_HeightMap", t2);
		GameObject.DestroyImmediate (c);
		GameObject.DestroyImmediate (t);

		//renderTexture

		
	}
	void OnGUI()
	{
 
		EditorGUILayout.BoundsField ("包围盒大小：", bounds);
		index = EditorGUILayout.Popup("高度图大小:",index, options);
		float [] ary = {maxx,maxy,maxz,minx,miny,minz};
		if (GUILayout.Button ("保存")) {
 
		string path = EditorUtility.SaveFilePanelInProject("Save prefab", sel.name + ".prefab", "prefab","Please enter a file name to save the texture to");

			if (path.Length == 0)
				return;
			buildHightMap (path);

 

			EditorUtility.DisplayDialog ("title", path, "确认", "取消");
		}
		//AssetDatabase.GetAssetPath
		//EditorUtility.DisplayDialog ("title", txt, "确认", "取消");
	}
	 
}
