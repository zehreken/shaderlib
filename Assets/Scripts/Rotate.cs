using UnityEngine;

public class Rotate : MonoBehaviour
{
	public float Speed;

	void Start()
	{
	}

	void Update()
	{
		transform.Rotate(Vector3.one, Speed * Time.deltaTime);
	}
}