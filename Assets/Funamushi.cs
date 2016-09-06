using UnityEngine;
using System.Collections;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class Funamushi : MonoBehaviour
{
    public float SpawnRange = 3.0f;

    const int INSTANCE_NUM = 8;

    private Vector3[] vertices;
    private int[]     triangles;
    private Vector2[] uvs;

    void Start ()
    {
        vertices = new Vector3[INSTANCE_NUM * 4];
        for (var i = 0; i < INSTANCE_NUM; ++i)
        {
            //float x = Random.Range(-SpawnRange, SpawnRange);
            //float z = Random.Range(-SpawnRange, SpawnRange);

            float x = Mathf.Cos(Mathf.PI * 2.0f * i / INSTANCE_NUM);
            float z = Mathf.Sin(Mathf.PI * 2.0f * i / INSTANCE_NUM);

            //x = i * 3.0f + 1.0f;
            //z = -3.0f;

            var point = new Vector3(x, 0.0f, z);
            vertices[i * 4 + 0] = point;
            vertices[i * 4 + 1] = point;
            vertices[i * 4 + 2] = point;
            vertices[i * 4 + 3] = point;
        }

        triangles = new int[INSTANCE_NUM * 6];
        for (int i = 0; i < INSTANCE_NUM; ++i)
        {
            triangles[i * 6 + 0] = i * 4 + 0;
            triangles[i * 6 + 1] = i * 4 + 1;
            triangles[i * 6 + 2] = i * 4 + 2;
            triangles[i * 6 + 3] = i * 4 + 2;
            triangles[i * 6 + 4] = i * 4 + 1;
            triangles[i * 6 + 5] = i * 4 + 3;
        }

        uvs = new Vector2[INSTANCE_NUM * 4];
        for (var i = 0; i < INSTANCE_NUM; ++i)
        {
            uvs[i * 4 + 0] = new Vector2 (0f, 0f);
            uvs[i * 4 + 1] = new Vector2 (1f, 0f);
            uvs[i * 4 + 2] = new Vector2 (0f, 1f);
            uvs[i * 4 + 3] = new Vector2 (1f, 1f);
        }

        Mesh mesh      = new Mesh ();
        mesh.name      = "MeshSnowFlakes";
        mesh.vertices  = vertices;
        mesh.triangles = triangles;
        mesh.uv        = uvs;
        mesh.bounds    = new Bounds(Vector3.zero, Vector3.one * 99999999);

        var mf = GetComponent<MeshFilter> ();
        mf.sharedMesh = mesh;
    }

    void Update()
    {
        var renderer = GetComponent<Renderer>();
        renderer.material.SetFloat("_PosParam", Mathf.Sin(Time.time) * 0.5f + 0.5f);
    }
}
