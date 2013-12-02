using System;
using System.Collections.Generic;
using System.Web.Mvc;
using FirmaTransportowa.Models;
using FirmaTransportowa.Models.Algorithm;

namespace FirmaTransportowa.Controllers
{
    public class CalculatePathController : Controller
    {
        //
        // GET: /CalculatePath/
        [HttpGet]
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Index(List<List<int>> matrix)
        {
            const int numberOfFireflies = 30;
            const int numberOfIterations = 2000;
            int[,] distance = new int[matrix.Count, matrix[0].Count];

            for(int i = 0; i < matrix.Count; i++)
            {
                for (int j = 0; j < matrix[i].Count; j++)
                {
                    distance[i, j] = matrix[i][j];
                }                
            }

            var alg = new FireflyAlgorithm(distance, numberOfFireflies, numberOfIterations);
            var result = alg.Execute();

            return Json(result, JsonRequestBehavior.AllowGet);
        }
    }
}