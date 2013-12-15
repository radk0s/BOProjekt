using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FirmaTransportowa.Models
{
    public class PathModel
    {
        public int iters { get; set; }
        public int fireflies { get; set; }
        public List<List<int>> matrix { get; set; }
    }
}