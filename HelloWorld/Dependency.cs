using HelloWorldClassLibrary;
using Microsoft.Extensions.DependencyInjection;

namespace HelloWorld
{
    public static class Dependency
    {
        public static void RegisterDependencies(this IServiceCollection collection)
        {
            collection.AddTransient<IConfiguration, Configuration>();
        }
    }
}