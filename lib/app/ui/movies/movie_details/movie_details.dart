import 'package:flutter/material.dart';
import 'package:latest_movies/app/ui/shared/button.dart';
import 'package:latest_movies/app/ui/shared/default_app_padding.dart';


import '../../../../router/router.dart';
import '../../shared/image.dart';

class MovieDetailsView extends StatelessWidget {

  const MovieDetailsView({super.key});
  final posterContainerHeight = 450.0;
  final trailerContainerHeight = 300.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.grey[900],
              padding: const EdgeInsets.all(40.0),
              height: posterContainerHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: posterContainerHeight - 40,
                    width: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.7),
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const AppImage(
                          imageUrl: "https://picsum.photos/id/20/200/300",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Peaky Blinders",
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  "4.5",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "(1234)",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              " | ",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "IMDb: ",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  "8.8/10",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "15+ | 3hr 10min | Action, Drama, Thriller | English | 2019",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // const Text(
                        //   "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ac urna quis ex eleifend tempus. In pharetra purus neque. Phasellus pulvinar justo at posuere iaculis. Aenean vulputate ac sem efficitur pretium. Sed viverra elit sed orci vestibulum ullamcorper. Donec tincidunt bibendum magna, ut mollis justo blandit ut. Vivamus eget ipsum augue. Donec condimentum felis augue, quis consequat est rhoncus sit amet. Sed dignissim ut nisi nec dictum. Integer mattis, purus gravida efficitur cursus, est mi auctor dui, eget maximus elit nisl a enim. Nunc vel tellus et nunc blandit porta. Mauris blandit nisi ut nulla tristique, nec feugiat ex molestie. \n\nUt aliquet lacinia libero, in aliquet ligula. Donec at aliquet felis. Proin metus enim, cursus nec sodales et, tincidunt id erat. Pellentesque pellentesque pulvinar tristique. Sed sed lacus metus. Suspendisse eros libero, viverra quis condimentum a, hendrerit vel dolor. Maecenas ultrices consectetur lacus commodo pulvinar. Nullam ultricies convallis aliquam. Nullam lorem felis, volutpat in malesuada sed, ullamcorper ut velit. Nam lobortis ornare quam, eget lacinia lorem convallis vitae. Duis et faucibus felis. Nunc fermentum scelerisque sapien, id molestie dui vehicula elementum. Sed a orci ut nisi vulputate facilisis. Fusce quis justo ut lectus scelerisque blandit quis quis sem. Morbi eget volutpat felis.",
                        //   style: TextStyle(
                        //     fontSize: 14.0,
                        //     color: Colors.white,
                        //     fontWeight: FontWeight.w300,
                        //   ),
                        // ),
                        const Expanded(child: SizedBox()),
                        AppButton.secondary(text: "Watch Now", onTap: () {
                          AppRouter.navigateToPage(Routes.playerView);
                        }),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: trailerContainerHeight,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultAppPadding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text(
                      "Trailers",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                      child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Container(
                        height: 200,
                        width: 400,
                        margin: EdgeInsets.only(
                            left: index == 0 ? 40 : 0,
                            right: index == 4 ? 40 : 0),
                        decoration: BoxDecoration(
                          color: Colors.grey[500],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(child: Text("Trailer $index")),
                      );
                    },
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: 10);
                    },
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
