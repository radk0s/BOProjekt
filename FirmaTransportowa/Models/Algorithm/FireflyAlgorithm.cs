using System;
using System.Collections.Generic;

namespace FirmaTransportowa.Models.Algorithm
{
    public class FireflyAlgorithm
    {
        private readonly int _numberOfPoints;
        private readonly int _numberOfFireflies;
        private readonly int[,] _distance;
        private readonly int _numberOfIterations;

        public FireflyAlgorithm(int[,] distance, int numberOfFireflies, int numberOfIterations)
        {
            _distance = distance;
            _numberOfPoints = distance.GetLength(1);
            _numberOfFireflies = numberOfFireflies;
            _numberOfIterations = numberOfIterations;
            if (distance.GetLength(0) != distance.GetLength(1))
            {
                throw new ArgumentException();
            }
        }

        public Object Execute()
        {
            var fireflies = new List<Firefly>();
            for (var i = 0; i < _numberOfFireflies; i++)
            {
                var f = new Firefly(_distance, _numberOfPoints);
                f.GeneratePermutation();
                fireflies.Add(f);
            }
            var best = fireflies[0];
            for (var i = 0; i < _numberOfFireflies; i++)
            {
                if (fireflies[i].FunctionValue() < best.FunctionValue())
                {
                    best = fireflies[i];
                }
            }
            for (var k = 0; k < _numberOfIterations; k++)
            {
                for (var i = 0; i < _numberOfFireflies; i++)
                {
                    for (var j = 0; j < _numberOfFireflies; j++)
                    {
                        if (fireflies[i].FunctionValue() <= fireflies[j].FunctionValue()) continue;
                        fireflies[i].MoveTo(fireflies[j]);
                        if (fireflies[i].FunctionValue() < best.FunctionValue())
                        {
                            best = fireflies[i];
                        }
                    }
                }
            }
            Console.WriteLine("Found the best rout. Lenght: " + best.FunctionValue());
            return new {permutation = best.GetPermutation(), cost = best.FunctionValue()};
        }
    }
}