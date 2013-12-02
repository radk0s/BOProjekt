using System;
using System.Collections.Generic;
using System.Linq;

namespace FirmaTransportowa.Models.Algorithm
{
    public class Firefly
    {
        private static readonly Random Random = new Random();
        private readonly int _pointsQuantity;
        private readonly int[,] _distance;
        public List<int> Permutation { get; private set; }

        public Firefly(int[,] dist, int pointsQuantity)
        {
            _distance = dist;
            _pointsQuantity = pointsQuantity;
        }

        public void GeneratePermutation()
        {
            Permutation = new List<int>();

            for (var i = 0; i < _pointsQuantity; i++)
            {
                Permutation.Add(i);
            }
            for (var i = 0; i < _pointsQuantity; i++)
            {
                var value = Random.Next(0, _pointsQuantity - 1);
                Swap(i, value);
            }
        }

        private void Swap(int i, int j)
        {
            var x = Permutation[i];
            Permutation[i] = Permutation[j];
            Permutation[j] = x;
        }

        private void Inversion(int i, int j)
        {
            for (int k = j; k > i; k--)
            {
                Swap(k - 1, k);
            }
        }

        public int FunctionValue()
        {
            var toReturn = 0;
            for (var i = 0; i < _pointsQuantity - 1; i++)
            {
                toReturn += _distance[Permutation[i], Permutation[i + 1]];
            }
            toReturn += _distance[Permutation[_pointsQuantity - 1], Permutation[0]];
            return toReturn;
        }

        public void Show()
        {
            var show = Permutation.Aggregate("", (current, i) => current + (i + " "));
            Console.WriteLine(show);
        }

        public List<int> GetPermutation()
        {
            return Permutation;
        }

        private static void MergeWithInversions(List<int> first, List<int> second, int start, int bound,
            ICollection<int[]> inversions, out List<int> merged, out int count)
        {
            merged = new List<int>();
            var i = 0;
            var j = 0;
            count = 0;
            var done = 0;
            while ((i < first.Count) && (j < second.Count))
            {
                merged.Add(Math.Min(first[i], second[j]));
                if (second[j] < first[i])
                {
                    count += first.Count - i;
                    var inversion = new[] {start + i + done, start + bound + j};
                    inversions.Add(inversion);
                    ++done;
                    ++j;
                }
                else
                {
                    ++i;
                }
            }
            merged.AddRange(first.GetRange(i, first.Count - i));
            merged.AddRange(second.GetRange(j, second.Count - j));
        }

        private static void MergeSortWithInversions(ref List<int> sortedList, int start, List<int[]> inversions,
            out int count)
        {
            count = 0;
            if (sortedList.Count == 1)
            {
                return;
            }
            var bound = sortedList.Count/2;
            var first = sortedList.GetRange(0, bound);
            var second = sortedList.GetRange(bound, sortedList.Count - bound);
            int count1;
            int count2;
            int count3;
            MergeSortWithInversions(ref first, start, inversions, out count1);
            MergeSortWithInversions(ref second, start + bound, inversions, out count2);
            MergeWithInversions(first, second, start, bound, inversions, out sortedList, out count3);
            count = count1 + count2 + count3;
        }

        private static List<int> GetPermutation(IEnumerable<int> first, IList<int> second)
        {
            return first.Select(second.IndexOf).ToList();
        }

        public void MoveTo(Firefly f)
        {
            var perm = GetPermutation(Permutation, f.Permutation);
            var invs = new List<int[]>();
            int count;
            MergeSortWithInversions(ref perm, 0, invs, out count);
            var quantity = Random.Next(0, invs.Count - 1);
            for (var i = 0; i < quantity; i++)
            {
                Inversion(invs[i][0], invs[i][1]);
            }
        }
    }
}