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

        static private int _fireflies = 10;
        static private int _iterations = 1000;

        [HttpGet]
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult SetParams(List<int> model)
        {
            _iterations = model[0];
            _fireflies = model[1];

            return Json("OK", JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult Index(List<List<int>> matrix)
        {
            int numberOfFireflies = _fireflies;
            int numberOfIterations = _iterations;
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