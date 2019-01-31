using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

//下一行是 namespace 声明。一个 namespace 里包含了一系列的类。HelloWorldApplication 命名空间包含了类 HelloWorld。
namespace HelloWorld {
    class HelloWorld
    {
        //下一行定义了 Main 方法，是所有 C# 程序的 入口点。Main 方法说明当执行时 类将做什么动作。
        //在函数的返回类型前加上static关键字,函数即被定义为静态函数。静态函数与普通函数不同，它只能在声明它的文件当中可见，不能被其它文件使用。
        static void Main(string[] args)
        {
            Debug.Log("hellow");
        }
    }

}

//public class HelloWorld : MonoBehaviour {

//	// Use this for initialization
//	void Start () {

//	}

//	// Update is called once per frame
//	void Update () {

//	}
//}
