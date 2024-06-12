import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sneaker_shop/model/shoemodel.dart';
import 'package:sneaker_shop/providers/sneakershopprovider.dart';
import 'package:sneaker_shop/screens/user/userappbar.dart';
import 'package:sneaker_shop/support/colors.dart';
import 'package:sneaker_shop/support/sizetile.dart';
import 'package:sneaker_shop/support/textstyles.dart';

class ScreenDetails extends StatefulWidget {
  final ShoeModel sneaker;

  const ScreenDetails({super.key, required this.sneaker});

  @override
  State<ScreenDetails> createState() => _ScreenDetailsState();
}

class _ScreenDetailsState extends State<ScreenDetails> {
  int activeindex = 0;
  final List<Image> imagesList = [];

  @override
  void initState() {
    loadImages();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<SneakerShopProvider>(context, listen: false)
        .setSelectedSizeNull();
    super.didChangeDependencies();
  }

  void loadImages() {
    for (var path in widget.sneaker.imagePath) {
      imagesList.add(Image.network(
        path,
        filterQuality: FilterQuality.high,
        fit: BoxFit.scaleDown,
      ));
    }
  }

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Consumer<SneakerShopProvider>(
      builder: (context, provider, child) {
        bool isSelectedSizeNull = provider.isSelectedSizeNull();
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: UserAppBar(text: widget.sneaker.name),
          body: Stack(
            children: [
              SvgPicture.asset(
                'assets/images/bg.svg',
                height: double.infinity,
                fit: BoxFit.fill,
              ),
              SizedBox(
                height: screenSize.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: imagesList.isNotEmpty
                          ? CarouselSlider(
                              items: imagesList,
                              options: CarouselOptions(
                                initialPage: 0,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    activeindex = index;
                                  });
                                },
                                enlargeCenterPage: true,
                                viewportFraction: 0.7,
                              ),
                            )
                          : Image.asset(
                              'assets/images/na.png',
                              color: Colors.redAccent[100],
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.center,
                            ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: AnimatedSmoothIndicator(
                        effect: const ColorTransitionEffect(
                          spacing: 12,
                          dotWidth: 10,
                          dotHeight: 10,
                          dotColor: Colors.white12,
                          activeDotColor: Colors.white,
                        ),
                        activeIndex: activeindex,
                        count: imagesList.length,
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height / 25,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: const LinearGradient(
                            end: Alignment.centerRight,
                            begin: Alignment.topLeft,
                            colors: [
                              Color.fromRGBO(53, 63, 84, 1),
                              Color.fromRGBO(34, 40, 52, 1),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.sneaker.brand,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                detailsContainerFirstHeadingTextStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '\u20B9 ${widget.sneaker.price}',
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                detailsContainerPriceTextStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height: 50,
                                      child: GridView.builder(
                                        itemCount: widget.sneaker
                                            .availableSizesandStock.length,
                                        scrollDirection: Axis.horizontal,
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                          mainAxisSpacing: 20,
                                          maxCrossAxisExtent: 70,
                                        ),
                                        itemBuilder: (context, index) {
                                          return SizeTile(
                                            size: widget.sneaker
                                                .availableSizesandStock[index],
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        controller: _scrollController,
                                        child: Text(
                                          widget.sneaker.description ?? '',
                                          style: descriptionWhiteTextStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: screenSize.height / 11,
                              width: screenSize.width,
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 1,
                                    spreadRadius: 0,
                                    offset: Offset(0, -3),
                                  ),
                                ],
                                color: detailsDescriptionBackgroundColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (!isSelectedSizeNull) {
                                    provider.addToCart(
                                      sneakerId: widget.sneaker.shoeId,
                                      size: provider.selectedSize!,
                                    );
                                  }
                                },
                                child: GlassmorphicContainer(
                                  alignment: Alignment.center,
                                  width: screenSize.width / 1.5,
                                  height: screenSize.height / 15,
                                  borderRadius: 10,
                                  linearGradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment(
                                      screenSize.width / 2000,
                                      screenSize.height / 350,
                                    ),
                                    colors: isSelectedSizeNull
                                        ? addToCartInactiveColors
                                        : addToCartActiveColors,
                                  ),
                                  border: 2,
                                  borderGradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withOpacity(0.6),
                                      Colors.black.withOpacity(0.6),
                                    ],
                                  ),
                                  blur: 200,
                                  child: Text(
                                    'Add To Cart',
                                    style: addToCartTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
