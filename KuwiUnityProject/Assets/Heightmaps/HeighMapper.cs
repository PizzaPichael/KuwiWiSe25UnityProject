using System.Collections.Generic;
using Unity.AppUI.UI;
using UnityEngine;
using UnityEngine.UIElements;

public class HeighMapper : MonoBehaviour
{
    public MeshFilter meshFilter;
    public float exaggerationFactor = 2f; // Adjustable in Inspector
    public Texture2D heightmap; // Grayscale image of earth's elevation
    
    private Vector3[] baseVertices;

    void Start()
    {
        
        mesh = new Mesh();
        GetComponent<MeshFilter>().mesh = mesh;
        CreateIcosphere();
        
        mesh = meshFilter.mesh;
        baseVertices = mesh.vertices;
        UpdateTerrain();
    }
    public int subdivisions = 3;  // Adjust this for vertex resolution
    public float radius = 1f;

    private Mesh mesh;

    

    void CreateIcosphere()
    {
        // Create initial icosahedron vertices and triangles
        var vertList = new List<Vector3>();
        var triList = new List<int>();

        float t = (1f + Mathf.Sqrt(5f)) / 2f;

        vertList.Add(new Vector3(-1, t, 0).normalized * radius);
        vertList.Add(new Vector3(1, t, 0).normalized * radius);
        vertList.Add(new Vector3(-1, -t, 0).normalized * radius);
        vertList.Add(new Vector3(1, -t, 0).normalized * radius);

        vertList.Add(new Vector3(0, -1, t).normalized * radius);
        vertList.Add(new Vector3(0, 1, t).normalized * radius);
        vertList.Add(new Vector3(0, -1, -t).normalized * radius);
        vertList.Add(new Vector3(0, 1, -t).normalized * radius);

        vertList.Add(new Vector3(t, 0, -1).normalized * radius);
        vertList.Add(new Vector3(t, 0, 1).normalized * radius);
        vertList.Add(new Vector3(-t, 0, -1).normalized * radius);
        vertList.Add(new Vector3(-t, 0, 1).normalized * radius);

        // 20 faces of the icosahedron
        int[] faces = {
            0,11,5, 0,5,1, 0,1,7, 0,7,10, 0,10,11,
            1,5,9, 5,11,4, 11,10,2, 10,7,6, 7,1,8,
            3,9,4, 3,4,2, 3,2,6, 3,6,8, 3,8,9,
            4,9,5, 2,4,11, 6,2,10, 8,6,7, 9,8,1
        };

        for (int i = 0; i < faces.Length; i++)
            triList.Add(faces[i]);

        // Subdivide triangles
        for (int i = 0; i < subdivisions; i++)
            Subdivide(ref vertList, ref triList);

        mesh.Clear();
        mesh.vertices = vertList.ToArray();
        mesh.triangles = triList.ToArray();
        mesh.RecalculateNormals();
        mesh.RecalculateBounds();
    }
    private int GetMiddlePoint(int p1, int p2, List<Vector3> vertices, Dictionary<long, int> cache, float radius)
    {
        long key = ((long)Mathf.Min(p1, p2) << 32) + Mathf.Max(p1, p2);
        if (cache.TryGetValue(key, out int ret)) return ret;

        Vector3 middle = ((vertices[p1] + vertices[p2]) / 2f).normalized * radius;
        int i = vertices.Count;
        vertices.Add(middle);

        cache.Add(key, i);
        return i;
    }

    void Subdivide(ref List<Vector3> vertices, ref List<int> triangles)
    {
        var newTriangles = new List<int>();
        var midPointCache = new Dictionary<long, int>();

        for (int i = 0; i < triangles.Count; i += 3)
        {
            int v1 = triangles[i];
            int v2 = triangles[i + 1];
            int v3 = triangles[i + 2];

            int a = GetMiddlePoint(v1, v2, vertices, midPointCache, radius);
            int b = GetMiddlePoint(v2, v3, vertices, midPointCache, radius);
            int c = GetMiddlePoint(v3, v1, vertices, midPointCache, radius);

            newTriangles.AddRange(new int[] { v1, a, c });
            newTriangles.AddRange(new int[] { v2, b, a });
            newTriangles.AddRange(new int[] { v3, c, b });
            newTriangles.AddRange(new int[] { a, b, c });
        }

        triangles = newTriangles;
    }

    public void UpdateTerrain()
    {
        Vector3[] vertices = new Vector3[baseVertices.Length];

        for (int i = 0; i < vertices.Length; i++)
        {
            Vector3 vertex = baseVertices[i].normalized; // Unit sphere point

            // Sample heightmap based on vertex direction converted to UV coordinates
            Vector2 uv = new Vector2(
                0.5f + Mathf.Atan2(vertex.z, vertex.x) / (2 * Mathf.PI),
                0.5f - Mathf.Asin(vertex.y) / Mathf.PI);

            float elevation = heightmap.GetPixelBilinear(uv.x, uv.y).grayscale;

            float scaledElevation = elevation * exaggerationFactor;

            vertices[i] = vertex * (1 + scaledElevation);
        }

        mesh.vertices = vertices;
        mesh.RecalculateNormals();
        mesh.RecalculateBounds();
    }
}